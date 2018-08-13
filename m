From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 0/3] WireGuard: Secure Network Tunnel
Date: Mon, 13 Aug 2018 11:04:35 -0700
Message-ID: <1534183475.7872.14.camel@HansenPartnership.com>
References: <20180731191102.2434-1-Jason@zx2c4.com>
         <1534174811.7872.3.camel@HansenPartnership.com>
         <CAHmME9raa81A_hH_Zykp2r8zOk0ySroFEsk+8384vnVOCuSa=g@mail.gmail.com>
         <1534181830.7872.10.camel@HansenPartnership.com>
         <CAHmME9pn+zm67mmDDrkMLpSAXNEugCT3z2L-QXO2eQw+31V=YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHmME9pn+zm67mmDDrkMLpSAXNEugCT3z2L-QXO2eQw+31V=YQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2018-08-13 at 10:55 -0700, Jason A. Donenfeld wrote:
> > but it's very hard for a flow classifier because you have to
> 
> The construction and identifier strings might not obviously help with
> the extremely narrow idea you've brought up, but it is very important
> for safely introducing additional versions. Namely, it prevents
> against cross-protocol key reuse attacks and type confusion bugs. So
> don't be too quick to dismiss the importance of these for
> accomplishing what we're after.

I'm not saying a hash check isn't important for safety; I'm saying that
if you only have a hash of a dynamic part plus the protocol identifier
to go on it makes far more work for the flow classifier.  You can see
this easily if you contemplate the idea that the hash might be the
algorithm being changed.

> > so lets pick one of the above and try it out.
> 
> We have, multiple times, and it's absolutely trivial to do and works
> well. The exact thing you're concerned about has already been
> researched and worked with on live systems quite a bit over the last
> 3 years, and it works in a pretty straight forward way. I'm not sure
> there's much more to add here: the thing you want is already there
> and has been tested extensively. At this point the "pick one and
> let's try it out!" is an old story, and the focus now is on making
> sure the code quality and netdev api usage is correct for merging

Great, thanks, I'll look forward to seeing it in v2 then.

James
