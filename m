From: "Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>
Subject: Re: ATH9K RNG
Date: Mon, 23 May 2016 10:39:06 +0000
Message-ID: <874m9pawjf.fsf@kamboji.qca.qualcomm.com>
References: <4722005.7KY1oJgCp9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4722005.7KY1oJgCp9-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org> (Stephan Mueller's message
	of "Mon, 23 May 2016 12:26:12 +0200")
Content-Language: en-US
Content-ID: <C4EBEE0C26CE5B4685CECF32B279E552-zC7DfRvBq/JWk0Htik3J/w@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> writes:

> considering the patch ed14dc0af7ccea867b479feb88efdfe43ca2a0f9 which adds the 
> invocation of add_hwgenerator_randomness to the ATH9K driver, may I ask about 
> more details about how you concluded that the data from the ATH chip is 
> entropic?
>
> In addition, can you please elaborate on the ATH9K_RNG_ENTROPY macro? I am 
> wondering about the multiplication of 320. If I understand the code right, the 
> return code of ath9k_rng_data_read returns the number of u32 values read from 
> the device, i.e. at most 320. With the ATH9K_RNG_ENTROPY macro, that return 
> value is multiplied by 320 (bytes?) converted into bits. I.e. it sounds to be 
> that the macro returns 320 u32 values times 320 bytes converted into bits. I 
> am wondering whether the macro should rather read  (((x) * 8 * 32) >> 10) -- 
> i.e. at most the entire array size holding the data in bits divided by 1024?

Please include linux-wireless (Cced) in the discussion. I don't remember
the details (and can't check right now) but there were discussions in
linux-wireless mailing list.

-- 
Kalle Valo--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
