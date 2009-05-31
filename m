From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and key/iv
 handling
Date: Sun, 31 May 2009 10:38:52 -0400
Message-ID: <4A22967C.3080304@redhat.com>
References: <20090531025720.GC9033@oblivion.subreption.com> <20090530.230213.73434433.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: research@subreption.com, linux-kernel@vger.kernel.org,
        pageexec@freemail.hu, linux-mm@kvack.org, torvalds@osdl.org,
        alan@lxorguk.ukuu.org.uk, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au
To: David Miller <davem@davemloft.net>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090530.230213.73434433.davem@davemloft.net>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

David Miller wrote:
> From: "Larry H." <research@subreption.com>
> Date: Sat, 30 May 2009 19:57:20 -0700
> 
>> [PATCH] Use kzfree in crypto API context initialization and key/iv handling
> 
> Thanks for not CC:ing the crypto list, and also not CC:'ing the
> crypto maintainer.
> 
> Your submissions leave a lot to be desired, on every level.

That's a pretty roundabout way of saying "I have no
technical objections" :)

-- 
All rights reversed.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
