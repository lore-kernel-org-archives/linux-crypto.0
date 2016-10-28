From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] nvmem: sunxi-sid: SID content is not a valid source of
 randomness
Date: Fri, 28 Oct 2016 14:37:20 +0200
Message-ID: <20161028123720.GA10889@Red>
References: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161024201020.h6akyqad2o42xkhq@lukather>
 <20161025053855.GA901@Red>
 <20161025090634.3dae9ad52ae8382dde6af4c8@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, wens@csie.org, srinivas.kandagatla@linaro.org,
 linux-crypto@vger.kernel.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
 linux-arm-kernel@lists.infradead.org
To: Jean-Francois Moine <moinejf@free.fr>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20161025090634.3dae9ad52ae8382dde6af4c8@free.fr>
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

On Tue, Oct 25, 2016 at 09:06:34AM +0200, Jean-Francois Moine wrote:
> On Tue, 25 Oct 2016 07:38:55 +0200
> LABBE Corentin <clabbe.montjoie@gmail.com> wrote:
> 
> > > On Sat, Oct 22, 2016 at 03:53:28PM +0200, Corentin Labbe wrote:
> > > > Since SID's content is constant over reboot,
> > > 
> > > That's not true, at least not across all the Allwinner SoCs, and
> > > especially not on the A10 and A20 that this driver supports.
> > > 
> > 
> > On my cubieboard2 (A20)
> > hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/nvmem 
> > 00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000200
> > cubiedev ~ # reboot
> > cubiedev ~ # hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/nvmem 
> > 00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH..ur|
> > 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000200
> > 
> > So clearly for me its constant.
> 
> Even after power off/power on?

Yes, even after remove of any power supply.
