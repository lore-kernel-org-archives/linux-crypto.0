From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: remove speck
Date: Mon, 6 Aug 2018 20:12:38 -0700
Message-ID: <20180807031237.GA779@sol.localdomain>
References: <20180806223300.113891-1-ebiggers@kernel.org>
 <20180806230437.21431-1-Jason@zx2c4.com>
 <20180807011937.GA133621@gmail.com>
 <CAHmME9oTApV-zHD60QPryaoQf45ODpG25Da5FgB8c+LO162gWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Greg Kaiser <gkaiser@google.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Samuel Neves <samuel.c.p.neves@gmail.com>,
 Michael Halcrow <mhalcrow@google.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-crypto@vger.kernel.org, Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
 linux-arm-kernel@lists.infradead.org, Paul Crowley <paulcrowley@google.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9oTApV-zHD60QPryaoQf45ODpG25Da5FgB8c+LO162gWQ@mail.gmail.com>
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

On Mon, Aug 06, 2018 at 10:38:23PM -0400, Jason A. Donenfeld wrote:
> On 8/6/18, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > For context, in your commit message can you include a link to my email
> > mentioning Android's Speck decision
> > (https://marc.info/?l=linux-crypto-vger&m=153359499015659)?
> 
> Sure.
> 
> >
> > Also: "speck" => "Speck".
> 
> Ack.
> 
> >
> > Also I think the fscrypt code points should be reserved so they don't
> > get reused for something else:
> >
> > #define FS_ENCRYPTION_MODE_SPECK128_256_XTS    7	/* removed */
> > #define FS_ENCRYPTION_MODE_SPECK128_256_CTS    8	/* removed */
> 
> I thought about this too, but it occurred to me it's highly improbable
> these were ever used, and I thought it shinier not to leave scars. But
> if you feel strongly about it, no problem, I'll fix that up and send
> in a v2 shortly.
> 
> >
> > For the record, I think the statements Paul and I have made evaluating
> > Speck from a technical perspective remain substantially accurate.
> 
> It wasn't my intention to relitigate this, hence the rather short
> commit message. You said your thing, Tomer said his, and now I'm just
> trying to clear out the leftover soda cans.
> 

Sure, neither do I.  My intention is more to make it clear that we still don't
know of any "backdoor" in Speck, or any weakness that would compromise its use
in practice.

I mention this because people are naturally going to be curious about that, e.g.
speculating that Google found a "backdoor" -- remember that we do have some good
cryptographers!  I'm just stating what we know, out of honesty and openness; I
don't really intend to be arguing for Speck with this statement, and in any case
we already made the decision to not use Speck.

Thanks,

- Eric
