From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] KEYS: reject NULL restriction string when type is
 specified
Date: Thu, 30 Nov 2017 17:22:05 -0800 (PST)
Message-ID: <alpine.OSX.2.21.1711301533110.40510@jsswain-mobl.amr.corp.intel.com>
References: <089e082676ecdedb0b055f394f11@google.com> <20171130205159.97771-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        syzbot
        <bot+25a1a3685abe943a89512250aece10bdd9aa4827@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751303AbdLABWG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 20:22:06 -0500
In-Reply-To: <20171130205159.97771-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Eric,

On Thu, 30 Nov 2017, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
>
> keyctl_restrict_keyring() allows through a NULL restriction when the
> "type" is non-NULL, which causes a NULL pointer dereference in
> asymmetric_lookup_restriction() when it calls strcmp() on the
> restriction string.
>
> But no key types actually use a "NULL restriction" to mean anything, so
> update keyctl_restrict_keyring() to reject it with EINVAL.

Since this fixes the bug for the asymmetric key type and ensures that 
other key types won't make the same mistake, I agree this is the way to 
fix it. I did not find any issues in the patch.

Thanks,

Mat


> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 97d3aa0f3134 ("KEYS: Add a lookup_restriction function for the asymmetric key type")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> security/keys/keyctl.c | 24 ++++++++++--------------
> 1 file changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index 76d22f726ae4..1ffe60bb2845 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -1588,9 +1588,8 @@ long keyctl_session_to_parent(void)
>  * The caller must have Setattr permission to change keyring restrictions.
>  *
>  * The requested type name may be a NULL pointer to reject all attempts
> - * to link to the keyring. If _type is non-NULL, _restriction can be
> - * NULL or a pointer to a string describing the restriction. If _type is
> - * NULL, _restriction must also be NULL.
> + * to link to the keyring.  In this case, _restriction must also be NULL.
> + * Otherwise, both _type and _restriction must be non-NULL.
>  *
>  * Returns 0 if successful.
>  */
> @@ -1598,7 +1597,6 @@ long keyctl_restrict_keyring(key_serial_t id, const char __user *_type,
> 			     const char __user *_restriction)
> {
> 	key_ref_t key_ref;
> -	bool link_reject = !_type;
> 	char type[32];
> 	char *restriction = NULL;
> 	long ret;
> @@ -1607,31 +1605,29 @@ long keyctl_restrict_keyring(key_serial_t id, const char __user *_type,
> 	if (IS_ERR(key_ref))
> 		return PTR_ERR(key_ref);
>
> +	ret = -EINVAL;
> 	if (_type) {
> -		ret = key_get_type_from_user(type, _type, sizeof(type));
> -		if (ret < 0)
> +		if (!_restriction)
> 			goto error;
> -	}
>
> -	if (_restriction) {
> -		if (!_type) {
> -			ret = -EINVAL;
> +		ret = key_get_type_from_user(type, _type, sizeof(type));
> +		if (ret < 0)
> 			goto error;
> -		}
>
> 		restriction = strndup_user(_restriction, PAGE_SIZE);
> 		if (IS_ERR(restriction)) {
> 			ret = PTR_ERR(restriction);
> 			goto error;
> 		}
> +	} else {
> +		if (_restriction)
> +			goto error;
> 	}
>
> -	ret = keyring_restrict(key_ref, link_reject ? NULL : type, restriction);
> +	ret = keyring_restrict(key_ref, _type ? type : NULL, restriction);
> 	kfree(restriction);
> -
> error:
> 	key_ref_put(key_ref);
> -
> 	return ret;
> }
>
> -- 
> 2.15.0.531.g2ccb3012c9-goog
>
>
