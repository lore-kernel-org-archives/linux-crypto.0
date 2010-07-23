From: Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] Adding ADMA support for PPC460EX DMA engine.
Date: Fri, 23 Jul 2010 08:15:14 +0200
Message-ID: <201007230815.14464.sr@denx.de>
References: <1279846638-22323-1-git-send-email-tmarri@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com,
	linux-crypto@vger.kernel.org, tmarri@amcc.com
To: linuxppc-dev@lists.ozlabs.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1279846638-22323-1-git-send-email-tmarri@amcc.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

Hi Marri,

On Friday 23 July 2010 02:57:18 tmarri@amcc.com wrote:
> From: Tirumala Marri <tmarri@amcc.com>
> 
>   This patch will add ADMA support for DMA engine and HW offload for
>   XOR/ADG (RAID-5/6) functionalities.
>   1. It supports memcpy, xor, GF(2) based RAID-6.
>   2. It supports interrupt based DMA completions.
>   3. Also supports memcpy in RAID-1 case.
> 
>   Kernel version: 2.6.35-rc5
> 
>   Testing:
>     Created RAID-5/6 arrays usign mdadm.
>     And ran raw IO and filesystem IO to the RAID array.
>     Chunk size 4k,64k was tested.
>     RAID rebuild , disk fail, resync tested.
> 
>   File names:
>     This code is similar to ppc440spe . So I named the files as
>     drivers/dma/ppc4xx/adma1.c and drivers/dma/ppc4xx/adma1.h

As you describe above, a lot of the code seems to be copied from 
drivers/dma/ppc4xx/adma.c/h. Wouldn't it make more sense to factor out the 
common code instead of duplicating it?
 
Thanks.

Cheers,
Stefan

--
DENX Software Engineering GmbH,      MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich,  Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-0 Fax: (+49)-8142-66989-80 Email: office@denx.de
