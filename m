From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 1/1] ARM: dts: NSP: Add crypto (SPU) to dtsi
Date: Fri, 17 Mar 2017 15:50:02 -0700
Message-ID: <ff62a275-25c7-2f68-7d15-67e533208ad2@gmail.com>
References: <1487798543-34229-1-git-send-email-steven.lin1@broadcom.com>
 <66ba937a-f1c3-1cae-ff2e-46a9d9c97344@gmail.com>
 <fd877ab2-48db-a677-b539-ba5ed55e75c6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, rob.rice@broadcom.com,
 linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Steve Lin <steven.lin1@broadcom.com>, herbert@gondor.apana.org.au,
 robh+dt@kernel.org, linux@armlinux.org.uk, ray.jui@broadcom.com,
 scott.branden@broadcom.com, jon.mason@broadcom.com, mark.rutland@arm.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <fd877ab2-48db-a677-b539-ba5ed55e75c6@gmail.com>
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

On 03/06/2017 11:22 AM, Florian Fainelli wrote:
> On 02/28/2017 12:31 PM, Florian Fainelli wrote:
>> On 02/22/2017 01:22 PM, Steve Lin wrote:
>>> Adds crypto hardware (SPU) to Northstar Plus device tree file.
>>>
>>> Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
>>
>> Applied, thanks!
> 
> And dropped, since there is a dependency on "ARM: dts: NSP: Add mailbox
> (PDC) to NSP" to be applied first.
> 
> Let's wait for the mailbox maintainer to chime in before I apply the
> following patches (in that order):
> 
> ARM: dts: NSP: Add mailbox (PDC) to NSP
> ARM: dts: NSP: Add crypto (SPU) to dtsi

Applied again.
-- 
Florian
