From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 00/11] crypto: omap HW crypto fixes
Date: Thu, 4 Aug 2016 13:28:35 +0300
Message-ID: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>, <davem@davemloft.net>,
 <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
 <linux-omap@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

Hi,

This revision took quite a bit time to craft due to the rework needed
for sham buffer handling and export/import. I ended up implementing
a flush functionality for draining out the sham buffer when doing
export/import; just shrinking the buffer to sufficiently small size
impacted the performance with small data chunks too much so I dropped
this approach.

The series also fixes a couple of existing issues with omap2/omap3
hardware acceleration, I ran a full boot test / crypto manager
test suite on all boards accessible to me now.

Based on top of latest mainline, which is somewhere before 4.8-rc1
as of writing this, I am unable to rebase the series during the next
three weeks so wanted to get this out now. Targeted for 4.9 merge
window, some fixes could be picked up earlier though if needed.

-Tero
