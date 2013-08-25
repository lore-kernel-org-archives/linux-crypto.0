From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 02/18] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
Date: Sun, 25 Aug 2013 17:53:09 +0200
Message-ID: <20130825155309.GA5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-3-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1377169317-5959-3-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2013-08-22 19:01:41, Lee, Chun-Yi wrote:
> Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
> first step of signature generation operation
> (RSASSA-PKCS1-v1_5-SIGN).

Is this your own code, or did you copy it from somewhere?

> +	if (!T)
> +		goto error_T;
> +
> +	memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[hash_algo].size);
> +	memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->digest_size);
> +
> +	/* 3) check If emLen < tLen + 11, output "intended encoded message length too short" */
> +	if (emLen < tLen + 11) {
> +		ret = EINVAL;
> +		goto error_emLen;
> +	}

Normal kernel calling convention is 0 / -EINVAL.

> +	memcpy(EM + 2, PS, emLen - tLen - 3);
> +	EM[2 + emLen - tLen - 3] = 0x00;
> +	memcpy(EM + 2 + emLen - tLen - 3 + 1, T, tLen);

ThisDoesNotLookLikeKernelCode, NoCamelCase, please.

> +	*_EM = EM;

And we don't usually use _ prefix like this.


> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
>  struct public_key_signature {
>  	u8 *digest;
>  	u8 digest_size;			/* Number of bytes in digest */
> +	u8 *S;				/* signature S of length k octets */

u8 *signature?

> +	size_t k;			/* length k of signature S */

u8 *signature_length.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
