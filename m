From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 7/7] ima: Support module-style appended signatures
 for appraisal
Date: Thu, 03 Aug 2017 10:37:45 -0400
Message-ID: <1501771065.27872.63.camel@linux.vnet.ibm.com>
References: <20170706221753.17380-1-bauerman@linux.vnet.ibm.com>
         <20170706221753.17380-8-bauerman@linux.vnet.ibm.com>
         <1501424988.9230.67.camel@linux.vnet.ibm.com>
         <87fud9yig8.fsf@linux.vnet.ibm.com>
         <1501714334.27872.38.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1501714334.27872.38.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2017-08-02 at 18:52 -0400, Mimi Zohar wrote:
> On Wed, 2017-08-02 at 14:42 -0300, Thiago Jung Bauermann wrote:
> > Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> > >> @@ -229,8 +251,24 @@ int ima_appraise_measurement(enum ima_hooks func,
> > >>  		goto out;
> > >>  	}
> > >> 
> > >> -	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
> > >> -	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
> > >> +	/*
> > >> +	 * Appended signatures aren't protected by EVM but we still call
> > >> +	 * evm_verifyxattr to check other security xattrs, if they exist.
> > >> +	 */
> > >> +	if (appraising_modsig) {
> > >> +		xattr_value_evm = NULL;
> > >> +		xattr_len_evm = 0;
> > >> +	} else {
> > >> +		xattr_value_evm = xattr_value;
> > >> +		xattr_len_evm = xattr_len;
> > >> +	}
> > >> +
> > >> +	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value_evm,
> > >> +				 xattr_len_evm, iint);
> > >> +	if (appraising_modsig && status == INTEGRITY_FAIL) {
> > >> +		cause = "invalid-HMAC";
> > >> +		goto out;
> > >
> > > "modsig" is special, because having any security xattrs is not
> > > required. This test doesn't prevent status from being set to
> > > "missing-HMAC". This test is redundant with the original tests below.
> > 
> > Indeed, that is wrong. I'm still a bit fuzzy about how EVM works and how
> > it interacts with IMA. The only way I can think of singling out modsig
> > without reintroduced the complex expression you didn't like in v2 is as
> > below. What do you think?
> 
> The original code, without any extra tests, should be fine.

There is one major difference.

EVM verifies a file's metadata has not been modified based on either
an HMAC or signature stored as security.evm.  Prior to the appended
signatures patch set, all files in policy required a security.evm
xattr. With IMA enabled we could guarantee that at least one security
xattr existed.  The only exception were new files, which hadn't yet
been labeled. 

With appended signatures, there is now no guarantee that at least one
security xattr exists.

Perhaps the code snippet below will help clarify the meaning of the
integrity_status results. 

        switch (status) {
        case INTEGRITY_PASS:
        case INTEGRITY_UNKNOWN:      
              break;		
        case INTEGRITY_NOXATTRS:        /* no EVM protected xattrs */
                if (appraising_modsig)
                        break;
        case INTEGRITY_NOLABEL:         /* no security.evm xattr */
                cause = "missing-HMAC";
                fail = 1;
                break;
        case INTEGRITY_FAIL:            /* invalid HMAC/signature */
        default:
                cause = "invalid-HMAC";
                fail = 1;
                break;
        }

Mimi

