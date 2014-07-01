From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+ (part1)
Date: Wed, 02 Jul 2014 00:42:06 +0200
Message-ID: <87y4wcog5d.fsf@free.fr>
References: <E1X20mL-00083I-Sv@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-arm-kernel@lists.infradead.org,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-samsung-soc@vger.kernel.org, kvm@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-omap@vger.kernel.org, kvmarm@lists.cs.columbia.edu
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <E1X20mL-00083I-Sv@rmk-PC.arm.linux.org.uk> (Russell King's
	message of "Tue, 01 Jul 2014 17:19:33 +0100")
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Russell King <rmk+kernel@arm.linux.org.uk> writes:

> ARMv6 and greater introduced a new instruction ("bx") which can be used
> to return from function calls.  Recent CPUs perform better when the
> "bx lr" instruction is used rather than the "mov pc, lr" instruction,
> and this sequence is strongly recommended to be used by the ARM
> architecture manual (section A.4.1.1).

For ARMv5 - XScale, and more specificaly the mioa701_bootresume.S path (suspend
to RAM) :
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
