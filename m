From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v14 02/10] iomap: Add big endian sparse annotations to
 mmio_{read|write}XXbe()
Date: Thu, 22 Mar 2018 11:28:44 -0600
Message-ID: <e183ca6b-8148-1210-8f00-3415fbad7e77@deltatee.com>
References: <20180322171703.4300-1-logang@deltatee.com>
 <20180322171703.4300-3-logang@deltatee.com>
 <20180322172747.4rjped3gojfuhuh2@ltop.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322172747.4rjped3gojfuhuh2@ltop.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3/22/2018 11:27 AM, Luc Van Oostenryck wrote:
> On Thu, Mar 22, 2018 at 11:16:55AM -0600, Logan Gunthorpe wrote:
>> Sparse produces a few warnings of the form:
>>
>> lib/iomap.c:84:9: warning: cast to restricted __be16
>>
>> (The kbuild robot has recently started running such checks)
> 
> Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> 

Thanks Luc!

Logan
