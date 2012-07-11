From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/4] Talitos: move the data structure into header file
Date: Tue, 10 Jul 2012 19:11:07 -0500
Message-ID: <20120710191107.28347d94783d8c001c67ce57@freescale.com>
References: <1341899809-20630-1-git-send-email-qiang.liu@freescale.com>
 <1341899809-20630-2-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, "David S.
 Miller" <davem@davemloft.net>, horia.geanta@freescale.com
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1341899809-20630-2-git-send-email-qiang.liu@freescale.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On Tue, 10 Jul 2012 13:56:46 +0800
Qiang Liu <qiang.liu@freescale.com> wrote:

> Move the declaration of talitos data structure into talitos.h.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---

this patch has already been submitted [1].

Subsequent patches in this series also don't apply cleanly:  can
you rebase onto [2], which is based on Herbert's cryptodev tree and
contain's Horia's four patches, and re-send?

Also note that upstream talitos does not yet contain NAPI support
[3].

Thanks,

Kim

[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg07299.html
[2] git://git.freescale.com/crypto/cryptodev.git
[3] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg07289.html
