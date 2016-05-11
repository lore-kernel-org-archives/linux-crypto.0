From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [RFC PATCH 2/8] KEYS: Provide keyctls to drive the new key type
 ops for asymmetric keys [ver 3]
Date: Wed, 11 May 2016 15:17:34 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605111426140.16566@mjmartin-mac01.local>
References: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk> <20160511142207.4743.40300.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160511142207.4743.40300.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Wed, 11 May 2016, David Howells wrote:

> diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
> index ca72b70a24b9..01c2ae28a8c0 100644
> --- a/Documentation/security/keys.txt
> +++ b/Documentation/security/keys.txt
> +     If the key needs to be unlocked with a password, a logon-type key that
> +     holds the password may be given as the password argument
...
> +     If the key must be unlocked with a password before it can be used,
> +     password_id should point to a logon-type key that holds this.

It should be noted that the password_id should be 0 if no password is to 
be used.

> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> new file mode 100644
> index 000000000000..7f51db984aaa
> --- /dev/null
> +++ b/security/keys/keyctl_pkey.c
> +long keyctl_pkey_e_d_s(int op,
...
> +	ret = params.key->type->asym_eds_op(&params, in, out);

Need to check for NULL asym_eds_op before calling.


Regards,

--
Mat Martineau
Intel OTC

