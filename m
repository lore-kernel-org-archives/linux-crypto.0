From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH 1/2] PPC4xx: Generelizing drivers/dma/ppc4xx/adma.c
Date: Thu, 23 Sep 2010 15:39:47 -0700
Message-ID: <d2d7c3068b5582bde7529ccc65d71e52@mail.gmail.com>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com>
	<4C9BB6EB.7020802@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: neilb@suse.de, yur@emcraft.com, linux-raid@vger.kernel.org,
	herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4C9BB6EB.7020802@intel.com>
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

>
> Will both versions of this driver exist in the same kernel build?  For
> example the iop-adma driver supports iop13xx and iop3xx, but we select
> the archtitecture at build time?  Or, as I assume in this case, will
> the
> two (maybe more?) ppc4xx adma drivers all be built in the same image,
> more like ioatdma?


[Marri] We select the architecture at build time.



>
> In the latter case I would recommend a file structure like:
>
> drivers/dma/ppc4xx/adma.c
> drivers/dma/ppc4xx/adma_440spe.c
> drivers/dma/ppc4xx/adma_460ex.c
>
> With patches to move the chipset specific pieces to their own file.
> Minimizing the code churn in adma.c, or at least showing a progression
> of what is unique and needs to be moved.
>
> This would be similar to how ioatdma is structured and compiles a
> single
> driver to cover the three major hardware revisions.


[Marri]Looks like this driver is similar to iop-adma driver.
