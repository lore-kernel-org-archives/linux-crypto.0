From: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] crypto: fix FTBFS with ARM SHA1-asm and THUMB2_KERNEL
Date: Mon, 21 Jan 2013 17:46:48 -0500 (EST)
Message-ID: <alpine.LFD.2.02.1301211739470.6300@xanadu.home>
References: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Russell King <linux@arm.linux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel@lists.infradead.org
To: Matt Sealey <matt@genesi-usa.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-reply-to: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 21 Jan 2013, Matt Sealey wrote:

> The optimized assembler SHA1 code for ARM does not conform to Thumb2
> register usage requirements, so it cannot be built when the kernel is
> configured with THUMB2_KERNEL.
> 
> Fix the FTBFS for now by preventing misconfigurations of the kernel.
> 
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>

A .arm directive at the top of the assembly code would be a better 
"fix", as that wouldn't reduce functionality.

Yet, I'd invite you to have a look at commit 638591cd7b in linux-next.


Nicolas
