From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 2/2] ARM: bcm283x: Add missing interrupt for RNG block
Date: Fri, 13 Apr 2018 14:39:56 -0700
Message-ID: <20180413213956.22464-1-f.fainelli@gmail.com>
References: <1511010253-5006-1-git-send-email-stefan.wahren@i2se.com>
 <1511010253-5006-3-git-send-email-stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
 linux-crypto@vger.kernel.org, Scott Branden <sbranden@broadcom.com>,
 linux-rpi-kernel@lists.infradead.org
To: bcm-kernel-feedback-list@broadcom.com,
 Stefan Wahren <stefan.wahren@i2se.com>, Matt Mackall <mpm@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Eric Anholt <eric@anholt.net>,
 Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1511010253-5006-3-git-send-email-stefan.wahren@i2se.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 18 Nov 2017 14:04:13 +0100, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> This patch adds the missing interrupt property to the RNG block
> of BCM283x.
> 
> Link: https://github.com/raspberrypi/linux/issues/2195
> CC: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---

Applied to devicetree/next, thanks!
--
Florian
