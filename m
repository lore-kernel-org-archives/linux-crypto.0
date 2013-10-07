From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Mon, 7 Oct 2013 17:48:26 +0200
Message-ID: <201310071748.27150.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de>
 <201309280535.33672.marex@denx.de>
 <632804650.191291.1381139440065.open-xchange@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Tobias Rauter <tobiasrauter@gmail.com>, linux-crypto@vger.kernel.org,
 Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: "Christoph G. Baumann" <cb@sgoc.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <632804650.191291.1381139440065.open-xchange@email.1und1.de>
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

Hello Christoph,

> Hello Marek,
> 
> > Marek Vasut <marex@denx.de> hat am 28. September 2013 um 05:35 geschrieben:
> > [...]
> >
> > > > 3) What are those ugly new IOCTLs in the dcp.c driver?
> > > 
> > > When I firstly posted the driver in the mailinglist, there where one
> > > person who actually used this interface (it was introduced in
> > > Freescale's SDK) to use the OTP keys for crypto. As far as I have
> > > seen, the crypto API does not support such keys (i.e. there seems to
> > > be no way to tell a driver to use some kind of special keys - which
> > > are not delivered by the user - via the API).
> > > Therefore I added this miscdevice and adopted Freescale's interface.
> > 
> > The keys are programmed into the OTP registers, correct? There is OCOTP d
> >river 
> >for the MX23/MX28 OTP hardware. This is what should have been used then. 
> > NOTE: This IOCTL interface seems like quite an abusive way to allow userl
> >and to 
> >access the crypto API in kernel. I understand this is used by some Freesc
> >ale tool, but won't it be better to fix the Freescale tool instead ?
> 
> the IOCTL interface is used to AES encrypt a bootstream with the AES key in
> OCOTP.
> The idea is that only the DCP can read/access the key once it has been
> programmed
> into the OCOTP. If the crypto API has means to tell the DCP to use the key
> from OCOTP, the tool from Freescale is a minor problem.

Ah right. I suspect the crypto API services shall not be exported into userland 
at all, yes ? So there has to be some kind of workaround here for this freescale 
tool, which is rather unfortunate.

Thanks for clearing this up.

Best regards,
Marek Vasut
