From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 4/7] alpha: provide ioread64 and iowrite64 implementations
Date: Thu, 22 Jun 2017 11:30:42 -0600
Message-ID: <0d2f1f7c-d014-5ddf-ad5c-64f13cb5a64a@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-5-logang@deltatee.com>
 <E70FB7EB-3A05-4A08-A85E-020F47751E3B@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
To: Stephen Bates <sbates@raithlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E70FB7EB-3A05-4A08-A85E-020F47751E3B@raithlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/22/2017 11:29 AM, Stephen  Bates wrote:
>> +#define iowrite64be(v,p) iowrite32(cpu_to_be64(v), (p))
>
> Logan, thanks for taking this cleanup on. I think this should be iowrite64 not iowrite32?

Yup, good catch. Thanks. I'll fix it in a v2 of this series.

Logan
