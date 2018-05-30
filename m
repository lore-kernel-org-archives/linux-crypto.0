From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2] async_pq: Remove VLA usage
Date: Wed, 30 May 2018 15:04:02 -0700
Message-ID: <CAPcyv4j9AoRtjpLfHX=gjgv35gNtb5fKt3rFaGA4ZPkPg1GfmQ@mail.gmail.com>
References: <20180505075854.192237-1-ksspiers@google.com> <CAPcyv4i__AQmCxM1rVBrLqXreMxQ5u9uRHRyJ=XZjDELxxJTzw@mail.gmail.com>
 <CAPcyv4jrUwXFrF7aB-bKqfZ=17T5ie27KEO0JYWD=ETAqOqA4g@mail.gmail.com> <CAGXu5jL5hzArDhKJzG+jd7wQVJfXGPT1tUys-FzNOS6MTE-jFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kyle Spiers <ksspiers@google.com>,
        David Miller <davem@davemloft.net>, ray.jui@broadcom.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>, vkoul@kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL5hzArDhKJzG+jd7wQVJfXGPT1tUys-FzNOS6MTE-jFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 30, 2018 at 2:33 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, May 29, 2018 at 3:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> [ add Vinod's korg address ]
>>
>> On Tue, May 29, 2018 at 3:37 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> [ adding linux-raid ]
>>>
>>> Apologies for the delay, the recent ping from Kees made me take a closer look.
>>>
>>> On Sat, May 5, 2018 at 12:58 AM, Kyle Spiers <ksspiers@google.com> wrote:
>>>> In the quest to remove VLAs from the kernel[1], this moves the
>>>> allocation of coefs and blocks from the stack to being kmalloc()ed.
>>>>
>>>> [1] https://lkml.org/lkml/2018/3/7/621
>>>>
>>>> Signed-off-by: Kyle Spiers <ksspiers@google.com>
>>>> ---
>>>> Forgot to add slab.h
>>>> ---
>>>>  crypto/async_tx/async_pq.c  | 18 ++++++++++++++----
>>>>  crypto/async_tx/raid6test.c |  9 ++++++++-
>>>>  2 files changed, 22 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
>>>> index 56bd612927ab..af1912313a23 100644
>>>> --- a/crypto/async_tx/async_pq.c
>>>> +++ b/crypto/async_tx/async_pq.c
>>>> @@ -194,9 +194,9 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
>>>>             (src_cnt <= dma_maxpq(device, 0) ||
>>>>              dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
>>>>             is_dma_pq_aligned(device, offset, 0, len)) {
>>>> -               struct dma_async_tx_descriptor *tx;
>>>> +               struct dma_async_tx_descriptor *tx = NULL;
>>>>                 enum dma_ctrl_flags dma_flags = 0;
>>>> -               unsigned char coefs[src_cnt];
>>>> +               unsigned char *coefs;
>>> At a minimum this needs to be GFP_NOIO since raid may be in the
>>> page-reclaim path.
>>>
>>> However, I think it may be better to allocate this with the rest of
>>> the stripe resources and pass it in as a scratch buffer. See the usage
>>> / implementation of scribble_alloc() in drivers/md/raid5.c.
>
> Given this:
>
>         int src_cnt = disks - 2;
> ...
>         BUG_ON(disks > 255 || ...)
>
> what about just making something like:
>
> #define MAX_DISKS 255
> ...
>         int src_cnt = disks - 2;
> ...
>         BUG_ON(disks > MAX_DISKS || ...)
> ...
>                  unsigned char coefs[MAX_DISKS];
>
> ?

Yeah, we were already potentially suffering a value that large on the
stack in a max config case anyway with the VLA. Looks ok to me.
