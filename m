From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 05/23] zinc: import Andy Polyakov's ChaCha20
 ARM and ARM64 implementations
Date: Fri, 28 Sep 2018 17:51:05 +0200
Message-ID: <CAKv+Gu8Pej+hKV7=RbwUkE4PtXjqHewRMfE7mYJLu+xnS+HFQw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-6-Jason@zx2c4.com>
 <CAKv+Gu8-EwxFhQSUPxjEvTA5ZPz34RieMokM6CUqwURDr74jtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8-EwxFhQSUPxjEvTA5ZPz34RieMokM6CUqwURDr74jtg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 28 September 2018 at 17:49, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 25 September 2018 at 16:56, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> These NEON and non-NEON implementations come from Andy Polyakov's
>> implementation, and are included here in raw form without modification,
>> so that subsequent commits that fix these up for the kernel can see how
>> it has changed. This awkward commit splitting has been requested for the
>> ARM[64] implementations in particular.
>>
>> While this is CRYPTOGAMS code, the originating code for this happens to
>> be the same as OpenSSL's commit 87cc649f30aaf69b351701875b9dac07c29ce8a2
>>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Based-on-code-from: Andy Polyakov <appro@openssl.org>
>> Cc: Samuel Neves <sneves@dei.uc.pt>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
>> Cc: Andy Polyakov <appro@openssl.org>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: linux-arm-kernel@lists.infradead.org
>
> As I mentioned before, I'd prefer this to be based on the original .pl
> but if I am the only one objecting to this, I guess I can live with
> it.
>

Note that I am getting bounces from LAKML because the patch is too big.
