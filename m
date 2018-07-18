From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: addu a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 16:22:35 -0400
Message-ID: <CACXcFm=URq_UnqdeEUAV0i6DSkvhE8VZW0KYcgQ=7601q_5NnQ@mail.gmail.com>
References: <20180718014344.1309-1-tytso@mit.edu> <20180718015154.GE3489@thunk.org>
 <CACXcFmk7D5t9yg9VxhKZgMvqK-LmFF0d7Dh9A3hsoGTfzzeM8A@mail.gmail.com> <20180718173621.GC30706@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Sandy Harris <sandyinchina@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718173621.GC30706@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Theodore Y. Ts'o <tytso@mit.edu> wrote:

>  For those people who are super paranoid and want a "true
> random number generator" (and the meaning of that is hazy) because a
> CRNG is Not Enough, my recommendation these days is that they get
> something like an open hardware RNG solution, such as ChaosKey from
> Altus Metrum[1].
>
> [1] https://altusmetrum.org/ChaosKey/

Yes & one of those can also solve any difficulty with random(4) at
startup. Another alternative, perhaps easier on some systems, is
Denker's Turbid trng:
https://www.av8n.com/turbid/paper/turbid.htm
