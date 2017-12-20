From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: use size_t consistently
Date: Wed, 20 Dec 2017 08:40:40 +0100
Message-ID: <20171220074040.GA9022@kroah.com>
References: <1513754611-14409-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1513754611-14409-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 20, 2017 at 07:23:31AM +0000, Gilad Ben-Yossef wrote:
> Fix declaration, implementation and wrapper function to use
> the same size_t type we actually define the parameter to be.
> 
> Fixes: 3f268f5d6669 ("staging: ccree: turn compile time debug log to params")
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

You forgot the reported-by: tag :(

I'll go add it...
