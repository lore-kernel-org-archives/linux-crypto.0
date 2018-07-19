From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] random: addu a config option to trust the CPU's hwrng
Date: Thu, 19 Jul 2018 22:17:03 +0200
Message-ID: <437d334a02acf3eff96a4f4da6079829f1de1197.camel@opteya.com>
References: <20180718014344.1309-1-tytso@mit.edu>
         <20180718015154.GE3489@thunk.org>
         <CACXcFmk7D5t9yg9VxhKZgMvqK-LmFF0d7Dh9A3hsoGTfzzeM8A@mail.gmail.com>
         <20180718173621.GC30706@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718173621.GC30706@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Le mercredi 18 juillet 2018 à 13:36 -0400, Theodore Y. Ts'o a écrit :

> For those people who are super paranoid and want a "true random
> number generator" (and the meaning of that is hazy) because a
> CRNG is Not Enough, my recommendation these days is that they get
> something like an open hardware RNG solution, such as ChaosKey from
> Altus Metrum[1].
> 
> [1] https://altusmetrum.org/ChaosKey/
> 

I could suggest "Infinite Noise" [1] keys which are also open hardware.
They use a different design, based on "modular multiplication" which
should be immune to most RF noise, 

The original model is currently sold out[2] but a fork exists[3].

One can also have a look at OneRNG [4][5] which uses a more usual
design but adds a nice EMI shield protection.

[1] https://github.com/waywardgeek/infnoise
[2] https://www.tindie.com/products/WaywardGeek/infinite-noise-true-random-number-generator/
[3] https://www.tindie.com/products/manueldomke/infinite-noise-trng-true-random-number-generator/
[4] http://onerng.info/
[5] http://moonbaseotago.com/onerng/

Regards.

-- 
Yann Droneaud
OPTEYA
