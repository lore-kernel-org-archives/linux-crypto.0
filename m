From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 15 Dec 2016 00:47:16 +0530
Message-ID: <CANc+2y7C-=S_5MZuqP0Q+y2FwHqS2_p9-iYuAu1A1tXqzxp_oA@mail.gmail.com>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au> <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au> <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au> <20161213141059.GB10647@Red>
 <20161214050551.GD9592@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
 Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
 maxime.ripard@free-electrons.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161214050551.GD9592@gondor.apana.org.au>
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

>> I have found two solutions:
>
> No we already have algif_rng so let's not confuse things even
> further by making hwrng take PRNGs.

Even if both the solutions could not be adopted I think there must be
a way for applications to use similar API to get true rng or prng.
Given the case that no user complained about prng data when using
/dev/hwrng is it safe to assume that the random data generated is
acceptable for users? If so, the drivers can be left without any
modification.

Should there be a mandate that driver will be accepted only when it
passes 'rngtest'. This will make sure that prng drivers won't get
added in future.

Regards,
PrasannaKumar
