From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Wed, 14 Dec 2016 11:39:52 +0530
Message-ID: <CAHv-k_8_pxWNkypY8uqLG-dsZfHjTdhbSEQNsjqNnStYq4xKTQ@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org> <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Milan,

Thank you for the reply.

On 13 December 2016 at 15:31, Milan Broz <gmazyland@gmail.com> wrote:

> I really do not think the disk encryption key management should be moved
> outside of dm-crypt. We cannot then change key structure later easily.

Yes, I agree. but the key selection based on sector number restricts the
option of having a larger block size used for encryption.

>> +     unsigned int key_size;
>> +     unsigned int key_extra_size;
>> +     unsigned int key_parts;      /* independent parts in key buffer */
>
> ^^^ these key sizes you probably mean by key management.

Yes, I mean splitting the keys into subkeys based on the keycount
parameter (as mentioned below) to the dm-crypt.

cipher[:keycount]-mode-iv:ivopts
aes:2-cbc-essiv:sha256

> It is based on way how the key is currently sent into kernel
> (one hexa string in ioctl that needs to be split) and have to be changed in future.

-Binoy
