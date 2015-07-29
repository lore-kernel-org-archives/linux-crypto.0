From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Wed, 29 Jul 2015 08:33:24 +0200
Message-ID: <2021681.UA65q8VJfQ@tauon.atsec.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com> <3945775.m5HblJPgiO@tauon.atsec.com> <CACXcFmnUcf66+X967JQL9mGrpa6ZYOqz99oK6JV8nFzABn=NZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Oleksij Rempel <linux-YEK0n+YFykbzxQdaRaTXBw@public.gmane.org>,
	"Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	"linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org
To: Sandy Harris <sandyinchina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACXcFmnUcf66+X967JQL9mGrpa6ZYOqz99oK6JV8nFzABn=NZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 28. Juli 2015, 13:41:57 schrieb Sandy Harris:

Hi Sandy,
>
>> However, the hwrandom framework does not provide any conditioning logic.
>
>At first sight, this sounds like a blunder to me, but I have not
>looked at hwrandom at all. Is there a rationale?

I think hwrandom is solely a framework to hook up RNG devices to user space. 
There is no massaging of data coming from the HW RNGs. Usually those HW RNGs 
all have their own conditioner and there is no need to do a conditioning 
again.
>
>For example, not building conditioning into that driver would make
>perfect sense if the output were just being fed into the random(4)
>which does plenty of mixing. The only problem then would be to make
>sure of giving random(4) reasonable entropy estimates.

hwrandom *may* be used to feed into the entropy pools. But there is no 
technical guarantee for that. Furthermore, I have seen use cases where the 
output of hwrandom is used for other purposes.

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
