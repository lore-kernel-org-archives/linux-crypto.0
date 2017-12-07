From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 01/10] staging: ccree: remove inline qualifiers
Date: Thu, 7 Dec 2017 09:00:11 +0200
Message-ID: <CAOtvUMcYuuH3ox4RLpaT5EsYUCZRxJX7vD=g7GbWjLbf3to7Hw@mail.gmail.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
 <1512309503-29766-2-git-send-email-gilad@benyossef.com> <20171204093639.7ctulxb4v2htqbmj@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171204093639.7ctulxb4v2htqbmj@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 4, 2017 at 11:36 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sun, Dec 03, 2017 at 01:58:12PM +0000, Gilad Ben-Yossef wrote:
>> The ccree drivers was marking a lot of big functions in C file as
>> static inline for no good reason. Remove the inline qualifier from
>> any but the few truly single line functions.
>>
>
> The compiler is free to ignore inline hints...  It probably would make
> single line functions inline anyway.
>

Yes. I think of it more as a note to the reader: "don't add stuff to
this function. it is meant to be short and simple".


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
