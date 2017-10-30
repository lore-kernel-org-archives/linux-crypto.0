From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hw_random: Include device.h instead of declaring struct device
Date: Mon, 30 Oct 2017 18:30:53 +0530
Message-ID: <CANc+2y4Lepxa+9X4ZAB68uuAyUBzTkd00DqjQGU8du-1FijbTA@mail.gmail.com>
References: <20171026134208.31368-1-prasannatsmkumar@gmail.com> <20171030065219.GB20573@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171030065219.GB20573@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 30 October 2017 at 12:22, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Oct 26, 2017 at 07:12:08PM +0530, PrasannaKumar Muralidharan wrote:
>> Include linux/device.h instead of declaring struct device.
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>
> Nack.  We should not include a header file when a simple forward
> declaration is enough.

No issues.

Regards,
PrasannaKumar
