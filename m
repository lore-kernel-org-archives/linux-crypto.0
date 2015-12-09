From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Wed, 9 Dec 2015 16:44:58 +0800
Message-ID: <20151209084458.GA26803@gondor.apana.org.au>
References: <rsahu@apm.com>
 <1447665169-14003-1-git-send-email-rsahu@apm.com>
 <CAFd313yzBgWhTD2+Lz+RsdziAuc2kdZPS1L2FExET5sLirs_DQ@mail.gmail.com>
 <20151209082748.GA26696@gondor.apana.org.au>
 <CAFd313z3zaXMAgKWa9KwQw1QxU4LuW_uoAz5_=42viYk2zaaOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, Vinod Koul <vinod.koul@intel.com>,
	dan.j.williams@intel.com, dmaengine@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com, linux-crypto@vger.kernel.org,
	Kaustubh Gondkar <kgondkar@apm.com>
To: Rameshwar Sahu <rsahu@apm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd313z3zaXMAgKWa9KwQw1QxU4LuW_uoAz5_=42viYk2zaaOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 09, 2015 at 02:13:32PM +0530, Rameshwar Sahu wrote:
>
> Yes, we are not upstream in-kernel users right now, but later client
> ma upstream there patches.

Well I'd prefer to not take any crypto drivers that don't have
in-kernel users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
