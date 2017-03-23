From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Thu, 23 Mar 2017 17:44:06 +0800
Message-ID: <20170323094406.GA6848@gondor.apana.org.au>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
 <CANc+2y5gv2ygSM4HF69XCW7Bb8UUHN+qJKq0os-mOvYknH+SeQ@mail.gmail.com>
 <20170320132858.GA27044@gondor.apana.org.au>
 <20170323082307.GB16625@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170323082307.GB16625@Red>
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

On Thu, Mar 23, 2017 at 09:23:07AM +0100, Corentin Labbe wrote:
> 
> Problem with this conversion, a huge regression for user space.
> Using hwrng is simple as cat /dev/hwrng.
> Using algif_rng via AF_ALG is ... unusable for the moment.
> Perhaps creating an user space tool (prng-tool which provide a cat /dev/hwrng replacement) is mandatory before any convertion.

Stephan may have a tool to do this.  Stephan?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
