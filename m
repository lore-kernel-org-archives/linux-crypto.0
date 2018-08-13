From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v1 0/3] WireGuard: Secure Network Tunnel
Date: Mon, 13 Aug 2018 10:55:09 -0700
Message-ID: <CAHmME9pn+zm67mmDDrkMLpSAXNEugCT3z2L-QXO2eQw+31V=YQ@mail.gmail.com>
References: <20180731191102.2434-1-Jason@zx2c4.com> <1534174811.7872.3.camel@HansenPartnership.com>
 <CAHmME9raa81A_hH_Zykp2r8zOk0ySroFEsk+8384vnVOCuSa=g@mail.gmail.com> <1534181830.7872.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1534181830.7872.10.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> but it's very hard for a flow classifier because you have to

The construction and identifier strings might not obviously help with
the extremely narrow idea you've brought up, but it is very important
for safely introducing additional versions. Namely, it prevents
against cross-protocol key reuse attacks and type confusion bugs. So
don't be too quick to dismiss the importance of these for
accomplishing what we're after.

> so lets pick one of the above and try it out.

We have, multiple times, and it's absolutely trivial to do and works
well. The exact thing you're concerned about has already been
researched and worked with on live systems quite a bit over the last 3
years, and it works in a pretty straight forward way. I'm not sure
there's much more to add here: the thing you want is already there and
has been tested extensively. At this point the "pick one and let's try
it out!" is an old story, and the focus now is on making sure the code
quality and netdev api usage is correct for merging
