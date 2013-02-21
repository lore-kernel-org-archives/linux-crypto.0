From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 17:40:25 +0100
Message-ID: <87ehg9k4cm.fsf@lebrac.rtp-net.org>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
 <201302211259.26763.arnd@arndb.de>
 <CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
 <201302211440.59577.arnd@arndb.de>
 <20130221152310.GA1906@pengutronix.de>
 <CAOMZO5Cw4fKY_hjtZtvR1sKFY8GvQMVN2RcRCS99FVRerS-Acg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: swarren@nvidia.com, herbert@gondor.apana.org.au,
 Arnd Bergmann <arnd@arndb.de>, tony@atomide.com,
 Sascha Hauer <s.hauer@pengutronix.de>, linux-crypto@vger.kernel.org,
 javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
 shawn.guo@linaro.org, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org, gcembed@gmail.com
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAOMZO5Cw4fKY_hjtZtvR1sKFY8GvQMVN2RcRCS99FVRerS-Acg@mail.gmail.com>
 (Fabio Estevam's message of "Thu, 21 Feb 2013 12:40:46 -0300")
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

Fabio Estevam <festevam@gmail.com> writes:
Hi,

> On Thu, Feb 21, 2013 at 12:23 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
>> Neither i.MX25, i.MX31 nor i.MX21 have this unit. I haven't checked the
>> others, but I assume this is i.MX27 only.
>
> There is Sahara variants on mx51/mx53.

How different are the variants ? I've a imx51 device with DT support so
if someone running sahara on a system with DT is needed, I can be this
person (as long as a way to test it is provided too).

Arnaud
