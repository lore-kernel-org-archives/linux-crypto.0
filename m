From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 12/18] MODSIGN: Export module signature definitions
Date: Thu, 26 Oct 2017 19:13:30 -0400
Message-ID: <1509059610.5886.145.camel@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
         <20171018005331.2688-13-bauerman@linux.vnet.ibm.com>
         <1509048728.5886.112.camel@linux.vnet.ibm.com>
         <87po99wmpq.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87po99wmpq.fsf@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2017-10-26 at 20:47 -0200, Thiago Jung Bauermann wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> 
> > On Tue, 2017-10-17 at 22:53 -0200, Thiago Jung Bauermann wrote:
> >> IMA will use the module_signature format for append signatures, so export
> >> the relevant definitions and factor out the code which verifies that the
> >> appended signature trailer is valid.
> >> 
> >> Also, create a CONFIG_MODULE_SIG_FORMAT option so that IMA can select it
> >> and be able to use validate_module_signature without having to depend on
> >> CONFIG_MODULE_SIG.
> >> 
> >> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
> >
> > Reviewed-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >
> > One minor comment below...
> 
> Thanks!
> 
> >> diff --git a/kernel/module_signing.c b/kernel/module_signing.c
> >> index 937c844bee4a..204c60d4cc9f 100644
> >> --- a/kernel/module_signing.c
> >> +++ b/kernel/module_signing.c
> >> @@ -11,36 +11,38 @@
> >> 
> >>  #include <linux/kernel.h>
> >>  #include <linux/errno.h>
> >> +#include <linux/module_signature.h>
> >>  #include <linux/string.h>
> >>  #include <linux/verification.h>
> >>  #include <crypto/public_key.h>
> >>  #include "module-internal.h"
> >> 
> >> -enum pkey_id_type {
> >> -	PKEY_ID_PGP,		/* OpenPGP generated key ID */
> >> -	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
> >> -	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
> >> -};
> >> -
> >> -/*
> >> - * Module signature information block.
> >> - *
> >> - * The constituents of the signature section are, in order:
> >> +/**
> >> + * validate_module_sig - validate that the given signature is sane
> >>   *
> >> - *	- Signer's name
> >> - *	- Key identifier
> >> - *	- Signature data
> >> - *	- Information block
> >> + * @ms:		Signature to validate.
> >> + * @file_len:	Size of the file to which @ms is appended.
> >>   */
> >> -struct module_signature {
> >> -	u8	algo;		/* Public-key crypto algorithm [0] */
> >> -	u8	hash;		/* Digest algorithm [0] */
> >> -	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
> >> -	u8	signer_len;	/* Length of signer's name [0] */
> >> -	u8	key_id_len;	/* Length of key identifier [0] */
> >> -	u8	__pad[3];
> >> -	__be32	sig_len;	/* Length of signature data */
> >> -};
> >> +int validate_module_sig(const struct module_signature *ms, size_t file_len)
> >> +{
> >> +	if (be32_to_cpu(ms->sig_len) >= file_len - sizeof(*ms))
> >> +		return -EBADMSG;
> >> +	else if (ms->id_type != PKEY_ID_PKCS7) {
> >> +		pr_err("Module is not signed with expected PKCS#7 message\n");
> >> +		return -ENOPKG;
> >> +	} else if (ms->algo != 0 ||
> >> +		   ms->hash != 0 ||
> >> +		   ms->signer_len != 0 ||
> >> +		   ms->key_id_len != 0 ||
> >> +		   ms->__pad[0] != 0 ||
> >> +		   ms->__pad[1] != 0 ||
> >> +		   ms->__pad[2] != 0) {
> >> +		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
> >> +		return -EBADMSG;
> >> +	}
> >> +
> >
> > When moving code from one place to another, it's easier to review when
> > there aren't code changes as well. In this case, the original code
> > doesn't have "else clauses".
> 
> Indeed. I changed the code back to using separate if clauses, making
> only the changes that are required for the refactoring.
> 
> > Here some of the if/then/else clauses
> > have braces others don't. There shouldn't be a mixture.
> 
> Does this still apply when the if clauses are separate as in the
> original code? Should the first if still have braces?

No, the original code was fine. 
