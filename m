From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Tue, 17 Nov 2015 13:51:10 -0800
Message-ID: <20151117215110.GB18515@kroah.com>
References: <1447420229-17911-1-git-send-email-clabbe.montjoie@gmail.com>
 <20151117140938.GH9546@gondor.apana.org.au>
 <20151117142603.GA1669@Red>
 <20151117142742.GA10019@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org,
	maxime.ripard@free-electrons.com, wens@csie.org,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151117142742.GA10019@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 17, 2015 at 10:27:42PM +0800, Herbert Xu wrote:
> On Tue, Nov 17, 2015 at 03:26:03PM +0100, LABBE Corentin wrote:
> >
> > I have lots of user reporting that they cannot use the device since it wont load.
> > For me it need to go stable since it respect all "stable rules", simple, tested, minimal, and fix a real bug that bother people.
> 
> Well it will hit stable eventually.  I just don't feel comfortable
> with sending it in straight away.

You can't send it in "straight away", the rule is that it has to be in
Linus's tree first, don't worry, you are doing it correctly.

thanks,

greg k-h
