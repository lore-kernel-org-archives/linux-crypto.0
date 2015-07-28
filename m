From: Sandy Harris <sandyinchina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Tue, 28 Jul 2015 13:41:57 -0400
Message-ID: <CACXcFmnUcf66+X967JQL9mGrpa6ZYOqz99oK6JV8nFzABn=NZA@mail.gmail.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>
	<3945775.m5HblJPgiO@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oleksij Rempel <linux-YEK0n+YFykbzxQdaRaTXBw@public.gmane.org>,
	"Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	"linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3945775.m5HblJPgiO-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 27, 2015 at 7:01 AM, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> wrote:

> This one does not look good for a claim that the RNG produces white noise. An
> RNG that is wired up to /dev/hwrng should produce white noise. Either by
> having an appropriate noise source or by conditioning the output of the noise
> source.

Yes.

> When conditioning the output, you have to be careful about the entropy claim.

A very good analysis of how to deal with this is in Denker's Turbid paper:
http://www.av8n.com/turbid/

In particular, see section 4.2 on Saturation

> However, the hwrandom framework does not provide any conditioning logic.

At first sight, this sounds like a blunder to me, but I have not
looked at hwrandom at all. Is there a rationale?

For example, not building conditioning into that driver would make
perfect sense if the output were just being fed into the random(4)
which does plenty of mixing. The only problem then would be to make
sure of giving random(4) reasonable entropy estimates.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
