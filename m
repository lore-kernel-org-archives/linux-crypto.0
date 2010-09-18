From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH 2/2] PPC4xx: Merge xor.h and dma.h into onefile ppc440spe-dma.h
Date: Sat, 18 Sep 2010 23:12:01 +0200
Message-ID: <20100918211201.EE714157D71@gemini.denx.de>
References: <1284774162-14652-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-raid@vger.kernel.org, herbert@gondor.apana.org.au,
	neilb@suse.de, yur@emcraft.com, linux-crypto@vger.kernel.org,
	dan.j.williams@intel.com, linuxppc-dev@lists.ozlabs.org
To: tmarri@apm.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1284774162-14652-1-git-send-email-tmarri@apm.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dear tmarri@apm.com,

In message <1284774162-14652-1-git-send-email-tmarri@apm.com> you wrote:
> From: Tirumala Marri <tmarri@apm.com>
> 
> This patch combines drivers/dma/ppc4xx/xor.h and driver/dma/dma/ppc4xx/dma.h
> into drivers/dma/ppc4xx/ppx440spe-dma.h .
> 
> Signed-off-by: Tirumala R Marri <tmarri@apm.com>
> ---
>  drivers/dma/ppc4xx/dma.h           |  223 -------------------------
>  drivers/dma/ppc4xx/ppc440spe-dma.h |  318 ++++++++++++++++++++++++++++++++++++
>  drivers/dma/ppc4xx/xor.h           |  110 -------------
>  3 files changed, 318 insertions(+), 333 deletions(-)

Please use -M with "git format-patch" so it detects renames (here we
should probably see a rename from dma.h into ppc440spe-dma.h [plus
some changes]) instead of a remove plus add file.

That would make it much easier to review your changes.

Thanks.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
It's a small world, but I wouldn't want to paint it.
