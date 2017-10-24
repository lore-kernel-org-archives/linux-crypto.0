From: Romain Izard <romain.izard.pro@gmail.com>
Subject: Re: Kernel panic when using ccm(aes) with the Atmel AES HW accelerator
Date: Tue, 24 Oct 2017 11:30:05 +0200
Message-ID: <CAGkQfmP5JPswyBBYJt_m1R-MPJdHMEC_pMG=3b-4RTm3Fi_G8Q@mail.gmail.com>
References: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
 <39a43561-e0e6-a3b7-e2c0-bd7e6bf1be47@microchip.com>
 <20171024032036.GA28462@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171024032036.GA28462@gondor.apana.org.au>
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

2017-10-24 5:20 GMT+02:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Mon, Oct 23, 2017 at 03:38:59PM +0300, Tudor Ambarus wrote:
>>
>> I will propose a fix, but I'm taking my time to better understand why
>> CTR requires to overwrite the iv with the last ciphertext block.
>
> That's an API requirement.  So we should fix ccm.
>

Where is the documentation for this API requirement?

I tried to find it in the kernel, but I only found a few comments in the
commit messages or in the implementations, but not an explicit
requirement.

Moreover, as it seems to be a common mistake in the crypto accelerators,
I believe that the algorithms' self-test should also check the IV at the
end of a request.

In the decryption case, the code should probably be shared for most
implementations: we need to save the input data before decryption in
case of in-place decoding, and restore it into the IV buffer before
returning to the caller.

-- 
Romain Izard
