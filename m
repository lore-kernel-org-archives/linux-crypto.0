From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH stable 3.10.y 00/18] Backport crypto fixes.
Date: Thu, 27 Oct 2016 17:06:14 +0200
Message-ID: <20161027150614.GB12104@1wt.eu>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andrey,

On Thu, Oct 27, 2016 at 05:29:33PM +0300, Andrey Ryabinin wrote:
> While fuzzing our 3.10 based kernel we observed some crashes, e.g:
>       http://lkml.kernel.org/r/<CACT4Y+aE-pNUnCLbDQkFQ9Y7QivN_g6hEuS7t1RpknPHFmHg+g@mail.gmail.com>
> 
> It appears that 3.10-stable lacks some crypto related fixes. Here is my attempt
> to backport them.
> Many patches didn't apply cleanly, so to make sure that my conflict resolution
> is correct I compared it with other stable trees.
(...)

Thanks a lot for doing this! I'm queueing them for next 3.10 and will merge
them unless I receive a nack for any of them.

Best regards,
Willy
