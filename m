From: Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v2 0/5] crypto: Speck support
Date: Thu, 26 Apr 2018 16:30:05 +0000
Message-ID: <CA+_SqcCXcwHyAGDS4dgzeaBBoHpcF98xK6Cr3-ZTLaHxEizWcQ@mail.gmail.com>
References: <20180212235209.117393-1-ebiggers@google.com>
 <CAHmME9oA4j=iGrrBYME92JfUsyi5r42PnAvzWiuXzGCRXMnXtA@mail.gmail.com>
 <20180424181623.GA174675@google.com>
 <CAHmME9qG+nPmj5c7hU4+STUsmWmwSBsKe-0mOLEXH+hJ1z4z=g@mail.gmail.com>
 <20180424224734.GA109345@google.com>
 <CAEX_ruHB7=zUuAWvbC9f6pDNhA4B32PGEkHi3QnPjRmRknrJ7w@mail.gmail.com>
 <20180425194919.GA79662@google.com>
 <CAEX_ruHoVRnBPazLhi6c+ps52yjb_SW=VfwxjiAW8izjvs24uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: noloader@gmail.com, Jason@zx2c4.com, Greg Kaiser <gkaiser@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>,
 Michael Halcrow <mhalcrow@google.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Patrik Torstensson <totte@google.com>, Alex Cope <alexcope@google.com>,
 Paul Lawrence <paullawrence@google.com>, linux-fscrypt@vger.kernel.org,
 linux-crypto@vger.kernel.org, gregkh@linuxfoundation.org,
 tashur@esat.kuleuven.be, linux-arm-kernel@lists.infradead.org
To: samuel.c.p.neves@gmail.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAEX_ruHoVRnBPazLhi6c+ps52yjb_SW=VfwxjiAW8izjvs24uQ@mail.gmail.com>
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

> Oh, OK, that sounds like something resembling Naor-Reingold or its
> relatives. That would work, but with 3 or 4 passes I guess it wouldn't
> be very fast.

It most resembles HCH mode https://eprint.iacr.org/2007/028 using two
passes of Poly1305, one pass of ChaCha20, and one invocation of a 128-bit
block cipher for the entire block. I have a writeup with a proof that it's
a secure tweakable SPRP, but we haven't actually implemented it yet so the
"Performance" section is a bit thin. From published benchmarks, Poly1305 is
around 2.3 cpb and ChaCha12 around 4.5 cbp on our target platform, so we're
hoping to achieve something a little over 7.1 cpb.

Right now we're in a situation where the people who can afford higher-end
devices with ARM CE get AES encryption, and the rest of the world gets no
encryption, or optional encryption that is rarely enabled because of the
performance cost. It's important to me to change that, and right now Speck
still looks like a good choice for achieving that end.
