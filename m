From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] crypto: remove speck
Date: Mon, 6 Aug 2018 23:15:26 -0400
Message-ID: <20180807031526.GD5048@thunk.org>
References: <20180806223300.113891-1-ebiggers@kernel.org>
 <20180806230437.21431-1-Jason@zx2c4.com>
 <20180807011937.GA133621@gmail.com>
 <CAHmME9oTApV-zHD60QPryaoQf45ODpG25Da5FgB8c+LO162gWQ@mail.gmail.com>
 <20180807031237.GA779@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Greg Kaiser <gkaiser@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Samuel Neves <samuel.c.p.neves@gmail.com>,
 Michael Halcrow <mhalcrow@google.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-crypto@vger.kernel.org, Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
 linux-arm-kernel@lists.infradead.org, Paul Crowley <paulcrowley@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180807031237.GA779@sol.localdomain>
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

On Mon, Aug 06, 2018 at 08:12:38PM -0700, Eric Biggers wrote:
> I mention this because people are naturally going to be curious about that, e.g.
> speculating that Google found a "backdoor" -- remember that we do have some good
> cryptographers!  I'm just stating what we know, out of honesty and openness; I
> don't really intend to be arguing for Speck with this statement, and in any case
> we already made the decision to not use Speck.

Let's be clear --- the arguments about whether or not to use Speck,
and whether or not to remove Speck from the kernel, are purely
political --- not techinical.

						- Ted
