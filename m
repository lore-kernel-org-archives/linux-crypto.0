From: "pascal@pabr.org" <pascal@pabr.org>
Subject: Re: Add support for the crypto engine on Orion5X
Date: Fri, 12 Jun 2009 14:09:44 +0200
Message-ID: <h0tgje$b2q$1@ger.gmane.org>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.arm.linux.org.uk
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk>
In-Reply-To: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
List-Unsubscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=unsubscribe>
List-Archive: <http://lists.arm.linux.org.uk/lurker/list/linux-arm-kernel.html>
List-Post: <mailto:linux-arm-kernel@lists.arm.linux.org.uk>
List-Help: <mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=help>
List-Subscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.arm.linux.org.uk
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk
List-Id: linux-crypto.vger.kernel.org

arm-kernel@ml.breakpoint.cc wrote:
> The crypto driver with flush_kernel_dcache_page()
> [...]
> |104857600 bytes (105 MB) copied, 31.3831 s, 3.3 MB/s

FYI I did tests with blocks of 4096 bytes (instead of dm-dcrypt's 512)
and the results suggest that the hardware can do at least 68 MB/s.
This makes sense since some of these devices come with gigabit ethernet.

Is there hope of achieving such throughputs with Linux and cryptoapi
on these SoCs ?  Or would this require very aggressive optimizations,
e.g. DMA'ing directly from the SATA interface to the CESA SRAM, and
then from the CESA SRAM to the ethernet interface ?

Pascal


-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
