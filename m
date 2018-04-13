From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 1/2] dt-binding: rng: Add interrupt property for BCM2835
Date: Fri, 13 Apr 2018 14:39:24 -0700
Message-ID: <b54e629b-e142-fdae-b166-124b991f8882@gmail.com>
References: <1511010253-5006-1-git-send-email-stefan.wahren@i2se.com>
 <1511010253-5006-2-git-send-email-stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 bcm-kernel-feedback-list@broadcom.com, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rpi-kernel@lists.infradead.org
To: Stefan Wahren <stefan.wahren@i2se.com>, Matt Mackall <mpm@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Eric Anholt <eric@anholt.net>,
 Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1511010253-5006-2-git-send-email-stefan.wahren@i2se.com>
Content-Language: en-US
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

On 11/18/2017 05:04 AM, Stefan Wahren wrote:
> As Sylvain Garrigues pointed out the BCM2835 RNG block has an
> interrupt. Also in preparation for Florian's upcoming patch series
> add this property to the binding. While we are at it fix the
> indenting of the example.
> 
> Link: https://github.com/raspberrypi/linux/issues/2195
> CC: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

Applied to devicetree/next, thanks!
-- 
Florian
