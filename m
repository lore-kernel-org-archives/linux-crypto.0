From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 2/2] crypto: tools: Add cryptostat userspace
Date: Mon, 1 Oct 2018 10:40:29 +0200
Message-ID: <CAKv+Gu9u+_Vyqo173qY16gBfYMvjf8u-4FZO9HLYQttOjfAvMw@mail.gmail.com>
References: <1537351855-16618-1-git-send-email-clabbe@baylibre.com>
 <1537351855-16618-3-git-send-email-clabbe@baylibre.com> <CAKv+Gu9VCZx=UHSoN7SexZeTzLK6yk9YAe5qMdhhDMUFnqTSCQ@mail.gmail.com>
 <CAKv+Gu8jgEyaUA2OOzxNT5nvWoC7qZgf+KazzH1Q5yWj60V2TQ@mail.gmail.com> <20181001072003.GA17784@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        nhorman@tuxdriver.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: LABBE Corentin <clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001072003.GA17784@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 1 October 2018 at 09:20, LABBE Corentin <clabbe@baylibre.com> wrote:
> On Fri, Sep 28, 2018 at 07:03:11PM +0200, Ard Biesheuvel wrote:
>> On 28 September 2018 at 15:13, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > On 19 September 2018 at 12:10, Corentin Labbe <clabbe@baylibre.com> wrote:
>> >> This patch adds an userspace tool for displaying kernel crypto API
>> >> statistics.
>> >>
>> >> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
>> >
>> > How do I actually build this thing?
>> >
>>
>> Never mind.
>
> Nope you are are right, this patchset clearly lack documentation.
>
> I will send a subsequent patch with it.
>
> Furthermore, since you seems to use cryptostat, what's your usage/opinion about it and what statistic it miss.
>

To be honest, I mainly used it to check whether a certain cipher is
being used at all or not, i.e., to check whether the my mac80211
interface is really using the arc4 and ccmp ciphers it allocates, or
whether they are simply there as a fallback.
