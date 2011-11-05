From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] crypto: driver for tegra AES hardware
Date: Sat, 5 Nov 2011 16:00:39 +0530
Message-ID: <4EB5104F.2050203@nvidia.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com> <20111104202202.882b4d84473ba616cacda7d7@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111104202202.882b4d84473ba616cacda7d7-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org


>> +	cmdq[1] = (u32)dd->ivkey_phys_base;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(cmdq); i++)
>> +		aes_writel(dd, cmdq[i], ICMDQUE_WR);
> ARRAY_SIZE is 2 here - why not use a single temporary variable and
> two individual aes_writel()s?

Removed 'i' and kept cmdq as it is. Adding 2 more variables seems
unnecessary.

>
>> +	if (ctx->flags & FLAGS_NEW_KEY) {
>> +		/* copy the key */
>> +		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
>> +		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
> do you really need the overlapping memset?

keylen < AES_HW_KEY_TABLE_LENGTH_BYTES. A key slot contains key, iv and
updated iv.

>> +	return IRQ_HANDLED;
> need to return IRQ_NONE if device reports no valid IRQ status.

I could not find a scenario where IRQ_NONE can be returned.
