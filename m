From: Sekhar Nori <nsekhar-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+
Date: Wed, 2 Jul 2014 17:01:04 +0530
Message-ID: <53B3ED78.1070608@ti.com>
References: <E1X20Rs-00082S-KI@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-1D3HCaltpLuhEniVeURVKkEOCMrvLtNR@public.gmane.org>,
        <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, <linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Kukjin
 Kim <kgene.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>,
        Magnus Damm
	<magnus.damm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gleb Natapov <gleb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Tony Lindgren
	<tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>,
        Sebastian Hesselbarth
	<sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
        Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>,
        Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>,
        Hans Ulli Kroll <ulli.kroll-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>,
        Haojian Zhuang
	<h
To: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Return-path: <davinci-linux-open-source-bounces-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
In-Reply-To: <E1X20Rs-00082S-KI-eh5Bv4kxaXIANfyc6IWni62ZND6+EDdj@public.gmane.org>
List-Unsubscribe: <http://linux.davincidsp.com/mailman/options/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=unsubscribe>
List-Archive: <http://linux.davincidsp.com/pipermail/davinci-linux-open-source>
List-Post: <mailto:davinci-linux-open-source-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
List-Help: <mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=help>
List-Subscribe: <http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=subscribe>
Sender: <davinci-linux-open-source-bounces-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
Errors-To: davinci-linux-open-source-bounces-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 01 July 2014 09:28 PM, Russell King wrote:
> ARMv6 and greater introduced a new instruction ("bx") which can be used
> to return from function calls.  Recent CPUs perform better when the
> "bx lr" instruction is used rather than the "mov pc, lr" instruction,
> and this sequence is strongly recommended to be used by the ARM
> architecture manual (section A.4.1.1).
> 
> We provide a new macro "ret" with all its variants for the condition
> code which will resolve to the appropriate instruction.
> 
> Rather than doing this piecemeal, and miss some instances, change all
> the "mov pc" instances to use the new macro, with the exception of
> the "movs" instruction and the kprobes code.  This allows us to detect
> the "mov pc, lr" case and fix it up - and also gives us the possibility
> of deploying this for other registers depending on the CPU selection.
> 
> Signed-off-by: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>

> ---

>  arch/arm/mach-davinci/sleep.S            |  2 +-

I build, boot and suspend-to-RAM tested on DA850 which should exercise
the path you modified. DaVinci devices are ARMv5 (ARM926) so the new bx
instruction does not really get used.

Acked-by: Sekhar Nori <nsekhar-l0cyMroinI0@public.gmane.org>

Thanks,
Sekhar
