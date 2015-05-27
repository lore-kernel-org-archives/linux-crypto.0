From: "Imre Kaloz" <kaloz-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 02/16] crypto: add a new driver for Marvell's CESA
Date: Wed, 27 May 2015 10:13:47 +0200
Message-ID: <op.xzabs9eb2s3iss@ecaz>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com> <1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com> <20150525075812.GA28689@gondor.apana.org.au> <20150525101016.252a1dc0@bbrezillon> <op.xy6tguug2s3iss@ecaz> <20150525130812.375cfebc@bbrezillon> <op.xy6us5v52s3iss@ecaz> <20150525131713.38acbad6@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Arnaud Ebalard" <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	"Thomas Petazzoni" <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	"Gregory CLEMENT" <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	"Jason Cooper" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	"Sebastian Hesselbarth" <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Andrew Lunn" <andrew-g2DYL2Zd6BY@public.gmane.org>,
	"Tawfik Bayouk" <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	"Lior Amsalem" <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	"Nadav Haklai" <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	"Eran Ben-Avi" <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	"Rob Herring" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	"Pawel Moll" <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	"Mark Rutland" <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	"Ian Campbell" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	"Kumar Gala" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boris Brezillon" <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150525131713.38acbad6@bbrezillon>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 25 May 2015 13:17:13 +0200, Boris Brezillon  
<boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:

>> Sorry, I didn't word it right - the series is missing the crypto nodes  
>> for
>> the orion, 375 and 38x platforms.
>
> I only add nodes for platforms I have tested on.
> If you're able to test on those platforms I'd be happy to include those
> changes in the upcoming version.

I would test on 38x but I don't have access to the cpu datasheets to fill  
in the missing pieces.. Thomas, Gregory, could one of you add those?


Imre
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
