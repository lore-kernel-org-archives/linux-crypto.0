From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 13 Dec 2016 16:33:15 +0100
Message-ID: <20161213153315.GC10647@Red>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
 <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au>
 <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au>
 <20161213141059.GB10647@Red>
 <CANc+2y5zegViTsPnuWZwWLUwdRk+ac6upaWOjH7iRFL_zEBxGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
 maxime.ripard@free-electrons.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y5zegViTsPnuWZwWLUwdRk+ac6upaWOjH7iRFL_zEBxGg@mail.gmail.com>
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

On Tue, Dec 13, 2016 at 08:53:54PM +0530, PrasannaKumar Muralidharan wrote:
> > What do you think about those two solutions ?
> 
> I prefer the second solution's idea of using two files (/dev/hwrng and
> /dev/hwprng). Upon having a quick glance it looks like (based on
> current_rng == prng check) that your current implementation allows
> only one rng device to be in use at a time. It would be better to have
> both usable at the same time. So applications that need pseudo random
> data at high speed can use /dev/prng while applications that require
> true random number can use /dev/rng. Please feel free to correct if my
> understanding of the code is incorrect. Along with this change I think
> changing the algif_rng to use this code if this solution is going to
> be used.
> 

No, there could be both device at the same time.
