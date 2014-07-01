From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+
 (part1)
Date: Tue, 01 Jul 2014 13:26:18 -0600
Message-ID: <53B30B5A.5030600@wwwdotorg.org>
References: <E1X20mL-00083I-Sv@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org,
	kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	davinci-linux-open-source-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
To: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1X20mL-00083I-Sv-eh5Bv4kxaXIANfyc6IWni62ZND6+EDdj@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 07/01/2014 10:19 AM, Russell King wrote:
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

Tested-by: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

(On an NVIDIA Tegra Jetson TK1 board, both CPU hotplug and system sleep
were tested, which are the use-cases that actually use the edited
assembly files)
