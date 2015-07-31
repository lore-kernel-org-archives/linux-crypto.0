From: Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Fri, 31 Jul 2015 10:08:42 +0300
Message-ID: <8738043ith.fsf@kamboji.qca.qualcomm.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>
	<3945775.m5HblJPgiO@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oleksij Rempel <linux-YEK0n+YFykbzxQdaRaTXBw@public.gmane.org>,
	"Pan\, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	"linville\@tuxdriver.com" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3945775.m5HblJPgiO-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org> (Stephan Mueller's message
	of "Mon, 27 Jul 2015 13:01:46 +0200")
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> writes:

>>-rw-rw-r-- 1 lex lex 2564096 Jul 27 11:36 hwrng.out
>>-rw-rw-r-- 1 lex lex 2468394 Jul 27 11:36 hwrng.out.bz2
>>
>>Do i understand it correctly, in case of hwrng bzip was able to find
>>enough pattern to compressed the data? Even with format overhead?
>>
>>I'm no an expert, help of an expert would be welcome, added some more
>>people to CC
>
> This one does not look good for a claim that the RNG produces white noise. An 
> RNG that is wired up to /dev/hwrng should produce white noise. Either by 
> having an appropriate noise source or by conditioning the output of the noise 
> source.
>
> When conditioning the output, you have to be careful about the entropy claim. 
> For example, you cannot state that the data stream from your noise source has 
> close to one bit of entropy for each obtained bit. Thus, the conditioner must 
> ensure that the data from the noise source is collected and its entropy is 
> maintained and accumulated.
>
> However, the hwrandom framework does not provide any conditioning logic. And I 
> would say that such conditioner logic should not reside in a driver either. I 
> would say that the discussed RNG does not seem fit for hooking it up with the 
> hwrandom framework.

Based on the discussion I'm going to revert this patch, at least for
now.

-- 
Kalle Valo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
