From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: arm64/speck - add NEON-accelerated
 implementation of Speck-XTS
Date: Fri, 16 Mar 2018 23:53:43 +0800
Message-ID: <20180316155343.GC7095@gondor.apana.org.au>
References: <20180305191707.143961-1-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Greg Kaiser <gkaiser@google.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Michael Halcrow <mhalcrow@google.com>, Patrik Torstensson <totte@google.com>,
 Paul Lawrence <paullawrence@google.com>, linux-fscrypt@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paul Crowley <paulcrowley@google.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180305191707.143961-1-ebiggers@google.com>
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

On Mon, Mar 05, 2018 at 11:17:07AM -0800, Eric Biggers wrote:
> Add a NEON-accelerated implementation of Speck128-XTS and Speck64-XTS
> for ARM64.  This is ported from the 32-bit version.  It may be useful on
> devices with 64-bit ARM CPUs that don't have the Cryptography
> Extensions, so cannot do AES efficiently -- e.g. the Cortex-A53
> processor on the Raspberry Pi 3.
> 
> It generally works the same way as the 32-bit version, but there are
> some slight differences due to the different instructions, registers,
> and syntax available in ARM64 vs. in ARM32.  For example, in the 64-bit
> version there are enough registers to hold the XTS tweaks for each
> 128-byte chunk, so they don't need to be saved on the stack.
> 
> Benchmarks on a Raspberry Pi 3 running a 64-bit kernel:
> 
>    Algorithm                              Encryption     Decryption
>    ---------                              ----------     ----------
>    Speck64/128-XTS (NEON)                 92.2 MB/s      92.2 MB/s
>    Speck128/256-XTS (NEON)                75.0 MB/s      75.0 MB/s
>    Speck128/256-XTS (generic)             47.4 MB/s      35.6 MB/s
>    AES-128-XTS (NEON bit-sliced)          33.4 MB/s      29.6 MB/s
>    AES-256-XTS (NEON bit-sliced)          24.6 MB/s      21.7 MB/s
> 
> The code performs well on higher-end ARM64 processors as well, though
> such processors tend to have the Crypto Extensions which make AES
> preferred.  For example, here are the same benchmarks run on a HiKey960
> (with CPU affinity set for the A73 cores), with the Crypto Extensions
> implementation of AES-256-XTS added:
> 
>    Algorithm                              Encryption     Decryption
>    ---------                              -----------    -----------
>    AES-256-XTS (Crypto Extensions)        1273.3 MB/s    1274.7 MB/s
>    Speck64/128-XTS (NEON)                  359.8 MB/s     348.0 MB/s
>    Speck128/256-XTS (NEON)                 292.5 MB/s     286.1 MB/s
>    Speck128/256-XTS (generic)              186.3 MB/s     181.8 MB/s
>    AES-128-XTS (NEON bit-sliced)           142.0 MB/s     124.3 MB/s
>    AES-256-XTS (NEON bit-sliced)           104.7 MB/s      91.1 MB/s
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
