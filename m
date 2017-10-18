From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v2] staging: ccree: fix boolreturn.cocci warning
Date: Wed, 18 Oct 2017 13:36:07 +1100
Message-ID: <20171018023607.GE30848@eros>
References: <20171016211906.GN16106@eros>
 <1508292773-15853-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org
To: sunil.m@techveda.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508292773-15853-1-git-send-email-sunil.m@techveda.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 18, 2017 at 07:42:53AM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
>
> Return "false" instead of 0.
> 
> This fixes the following coccinelle warning:
> WARNING: return of 0/1 in function 'ssi_is_hw_key' with return type bool.

So close! The order of problem description and fix is inverted. What about

```
coccinelle emits: WARNING: return of 0/1 in function 'ssi_is_hw_key' with
return type bool.

Return "false" instead of 0.
```


Good luck,
Tobin.
