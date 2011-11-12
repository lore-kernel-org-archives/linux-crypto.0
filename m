From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] crypto: driver for tegra AES hardware
Date: Sat, 12 Nov 2011 15:52:32 +0530
Message-ID: <4EBE48E8.60205@nvidia.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com> <20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111105181025.69918e625a169ccb30d9b7c8-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org


>> +	/* assign new context to device */
>> +	ctx->dd = dd;
>> +	dd->ctx = ctx;
>> +
>> +	if (ctx->flags & FLAGS_NEW_KEY) {
>> +		/* copy the key */
>> +		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
>> +		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
> these really should be writes to mutually exclusive addresses.

Why?

>> +	/* copy the key to the key slot */
>> +	memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
>> +	memcpy(dd->ivkey_base, seed + DEFAULT_RNG_BLK_SZ, AES_KEYSIZE_128);
> should be to mutually exclusive addresses

Why?
