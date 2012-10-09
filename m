From: Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to
 remove include plat/cpu.h
Date: Tue, 9 Oct 2012 09:20:03 +0300
Message-ID: <20121009092003.3f3d271a035595ef8fbb1e76@bitmer.com>
References: <20121008173452.10603.53886.stgit@muffinssi>
 <20121008173557.10603.18539.stgit@muffinssi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: alsa-devel@alsa-project.org, Deepak Saxena <dsaxena@plexity.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, Venkatraman S <svenkatr@ti.com>,
 Vinod Koul <vinod.koul@intel.com>, Matt Mackall <mpm@selenic.com>,
 Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-mmc@vger.kernel.org,
 linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Peter Ujfalusi <peter.ujfalusi@ti.com>, Chris Ball <cjb@laptop.org>,
 Dan Williams <djbw@fb.com>, linux-omap@vger.kernel.org,
 Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20121008173557.10603.18539.stgit@muffinssi>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 08 Oct 2012 10:35:57 -0700
Tony Lindgren <tony@atomide.com> wrote:

> - omap-dma.c and omap-pcm.c can test the arch locally as
>   omap1 and omap2 cannot be compiled together because of
>   conflicting compiler flags
...
>  sound/soc/omap/omap-pcm.c         |    9 +++++++--

Build tested above for omap1 and omap2+.

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
