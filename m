From: leroy christophe <christophe.leroy-GgN8y9CXRhA@public.gmane.org>
Subject: Re: [PATCH 0/17] crypto: talitos - Add support for SEC1
Date: Fri, 06 Mar 2015 07:44:29 +0100
Message-ID: <54F94CCD.8030807@c-s.fr>
References: <20150305164605.E65D81A241C@localhost.localdomain> <20150305182101.6db66e228f519476f0751c13@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150305182101.6db66e228f519476f0751c13-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



Le 06/03/2015 01:21, Kim Phillips a =E9crit :
> On Thu, 5 Mar 2015 17:46:05 +0100
> Christophe Leroy <christophe.leroy-GgN8y9CXRhA@public.gmane.org> wrote:
>
>> [15/17] crypto: talitos - Implementation of SEC1
> ...
>
>> [16/17] crypto: talitos - SEC1 bugs on 0 data hash
>> [17/17] crypto: talitos - Update DT bindings with SEC1
> This patchseries doesn't apply, at least on top of Herbert's
> cryptodev-2.6 tree, as of today:
>
> Applying: crypto: talitos - Implementation of SEC1
> error: patch failed: drivers/crypto/talitos.c:655
> error: drivers/crypto/talitos.c: patch does not apply
It was applying ok on linux-next as of yesterday.
I will rebase the serie on cryptodev-2.6

Christophe

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
