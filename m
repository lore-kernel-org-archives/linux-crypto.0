From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] PPC4xx: Merge xor.h and dma.h into onefile
	ppc440spe-dma.h
Date: Thu, 23 Sep 2010 13:29:47 -0700
Message-ID: <AANLkTin2pyo0Ua952poK8E+-bdeKMfYd9nyd-5tx7RD9@mail.gmail.com>
References: <1284774162-14652-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: neilb@suse.de, yur@emcraft.com, linux-raid@vger.kernel.org,
	herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: tmarri@apm.com
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1284774162-14652-1-git-send-email-tmarri@apm.com>
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

On Fri, Sep 17, 2010 at 6:42 PM,  <tmarri@apm.com> wrote:
> From: Tirumala Marri <tmarri@apm.com>
> This patch combines drivers/dma/ppc4xx/xor.h and driver/dma/dma/ppc4xx/dma.h
> into drivers/dma/ppc4xx/ppx440spe-dma.h .
>

Is this just code churn, or do we gain anything by combining these
header files?  Don't add "ppc440spe-" back to the prefix, we're
already in the ppc4xx directory, unless the file will only contain
definitions that are relevant to ppc440spe.

--
Dan
