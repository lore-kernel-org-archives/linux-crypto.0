From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ima: Support appended signatures for appraisal
Date: Wed, 26 Apr 2017 17:40:27 -0300
Message-ID: <2691998.fl6SjX7UkO@morokweng>
References: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com> <1492546666-16615-7-git-send-email-bauerman@linux.vnet.ibm.com> <1493205679.3908.76.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1493205679.3908.76.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Mimi,

Thanks for your review.

Am Mittwoch, 26. April 2017, 07:21:19 BRT schrieb Mimi Zohar:
> On Tue, 2017-04-18 at 17:17 -0300, Thiago Jung Bauermann wrote:
> > This patch introduces the appended_imasig keyword to the IMA policy syntax
> > to specify that a given hook should expect the file to have the IMA
> > signature appended to it.  Here is how it can be used in a rule:
> > 
> > appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig
> > appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig|imasig
> > 
> > In the second form, IMA will accept either an appended signature or a
> > signature stored in the extended attribute. In that case, it will first
> > check whether there is an appended signature, and if not it will read it
> > from the extended attribute.
> 
> An appended signature should be another place to look for a signature,
> when a signature is required, but it shouldn't make a difference where
> the signature is located.  "imasig" could have implied to look for the
> signature in both places - xattr or appended.  So the new option is
> just a hint - a performance improvement.
> 
> This might seem picayune, but the difference between "expect" vs.
> "hint" impacts the code. (Further explanation inline.)

Thanks, I just learned a new word. :-)

If appended_imasig is just a performance improvement, is it really necessary? 
Perhaps if CONFIG_IMA_APPENDED_SIG is enabled then imasig would imply always 
first looking for an appended signature.

My first impression is that yes, it's necessary because pointlessly checking 
for an appended signature at the end of every file covered by FILE_CHECK could 
have a performance impact on the system. On the other hand, it's just a memcmp 
and that may be negligible compared to the cost of reading an xattr. II'll 
have to measure that...

> > diff --git a/security/integrity/ima/ima_main.c
> > b/security/integrity/ima/ima_main.c index 2aebb7984437..994ee420b2ec
> > 100644
> > --- a/security/integrity/ima/ima_main.c
> > +++ b/security/integrity/ima/ima_main.c
> > @@ -16,6 +16,9 @@
> > 
> >   *	implements the IMA hooks: ima_bprm_check, ima_file_mmap,
> >   *	and ima_file_check.
> >   */
> > 
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > 
> >  #include <linux/module.h>
> >  #include <linux/file.h>
> >  #include <linux/binfmts.h>
> > 
> > @@ -228,9 +231,30 @@ static int process_measurement(struct file *file,
> > char *buf, loff_t size,> 
> >  	template_desc = ima_template_desc_current();
> >  	if ((action & IMA_APPRAISE_SUBMASK) ||
> > 
> > -		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
> > -		/* read 'security.ima' */
> > -		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
> > +		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0) {
> > +#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
> 
> Using "ifdef" in C code is really discouraged. Normally, it is an
> indication that the code needs to be re-factored.  Assuming we really
> need a new CONFIG option, which I'm not sure that we do, I would move
> the appended signature code to its own file, define stub functions in
> ima.h, and update the Makefile.

I didn't like the #ifdef here either and tried to find an alternative, but 
couldn't come up with something that was actually better. Perhaps it'll be 
easier with the changes needed in process_measurement to try reading the xattr 
if the appended sig fails.

I decided to add a new CONFIG option because otherwise CONFIG_IMA_APPRAISE 
would have to start depending on CONFIG_KEYS, CONFIG_PKCS7_MESSAGE_PARSER, 
CONFIG_X509_CERTIFICATE_PARSER and others. If you don't mind the extra 
dependencies, I can remove the CONFIG option.

> > +		unsigned long digsig_req;
> > +
> > +		if (iint->flags & IMA_APPENDED_DIGSIG_REQUIRED) {
> > +			if (!buf || !size)
> > +				pr_err("%s doesn't support appended_imasig\n",
> > +				       func_tokens[func]);
> 
> The policy parsing should prevent defining appended_imasig on
> inappropriate hooks.  Since the iint->flags might be shared between
> hooks, we might still need to test buf, but it could be simplified to:
> 
> if (!buf && iint->flags & IMA_APPENDED_DIGSIG_REQUIRED) {

That would require that me maintain a list of IMA hooks that use 
kernel_read_file and update it if any hook is converted to use it. I can do 
that if you think it's worth it (it is if it's unlikely or infrequent that 
hooks get converted to kernel_read_file).

I could also implement appended_imasig for hooks which need IMA to read the 
file and remove the restriction altogether. I'd have to check how hard that 
would be. Also not sure how useful it would be in practice to have those hooks 
supporting an appended signature.

> > +			else
> > +				ima_read_appended_sig(buf, &size, &xattr_value,
> > +						      &xattr_len);
> > +		}
> > +
> > +		/*
> > +		 * Don't try to read the xattr if we require an appended
> > +		 * signature but failed to get one.
> > +		 */
> 
> If the appended_sig is just a hint as to where the signature is
> located, then we should read the xattr, even if IMA_DIGSIG_REQUIRED is
> not specified.  ima_appraise_measurement() should be updated to
> require a signature if either IMA_DIGSIG_REQUIRED or
> IMA_APPENDED_SIGNATURE_REQUIRED are specified.  

Indeed.

> Part of the confusion might be due to the naming
> -"IMA_APPENEDED_SIGNATURE_REQUIRED".

Right, not a good name. I'll change that.

> > +		digsig_req = iint->flags & IMA_DIGSIG_REQUIRED_MASK;
> > +		if (!xattr_len && digsig_req != IMA_APPENDED_DIGSIG_REQUIRED)
> > +#endif /* CONFIG_IMA_APPRAISE_APPENDED_SIG */
> 
> Is limiting the "if" to the ifdef really necessary? 

Hopefully not after the changes to make process_measurement try one sig and 
then the other.

> >  	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
> 
> Unfortunately, if the hash algorithm in the appended signature and the
> xattr are not the same, then we would need to re-calculate the file
> hash.

I think the most common case for the appended sig verification to fail will be 
that it won't be there than the signature actually failing.

Having to rehash the file is unfortunate but how frequently would that happen?

-- 
Thiago Jung Bauermann
IBM Linux Technology Center

