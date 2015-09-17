From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 1/7] Documentation: hw_random: Fix device node name
 reference /dev/hw_random => /dev/hwrng
Date: Thu, 17 Sep 2015 14:45:51 +0100
Message-ID: <1442497557-9271-2-git-send-email-lee.jones@linaro.org>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lee Jones <lee.jones@linaro.org>, kernel@stlinux.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, peter@korsgaard.com, festevam@gmail.com,
 kieranbingham@gmail.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

In April 2009, commit d405640 ("Driver Core: misc: add node name support
for misc devices.") inadvertently changed the device node name from
/dev/hw_random to /dev/hwrng.  Since 6 years has passed since the change
it seems unpractical to change it back, as this node name is probably
considered ABI by now.  So instead, we'll just change the documentation
to match the current situation.

NB: It looks like rng-tools have already been updated.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/hw_random.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/hw_random.txt b/Documentation/hw_random.txt
index 026e237..fce1634 100644
--- a/Documentation/hw_random.txt
+++ b/Documentation/hw_random.txt
@@ -3,7 +3,7 @@ Introduction:
 	The hw_random framework is software that makes use of a
 	special hardware feature on your CPU or motherboard,
 	a Random Number Generator (RNG).  The software has two parts:
-	a core providing the /dev/hw_random character device and its
+	a core providing the /dev/hwrng character device and its
 	sysfs support, plus a hardware-specific driver that plugs
 	into that core.
 
@@ -14,7 +14,7 @@ Introduction:
 
 		http://sourceforge.net/projects/gkernel/
 
-	Those tools use /dev/hw_random to fill the kernel entropy pool,
+	Those tools use /dev/hwrng to fill the kernel entropy pool,
 	which is used internally and exported by the /dev/urandom and
 	/dev/random special files.
 
@@ -32,13 +32,13 @@ Theory of operation:
 	The rng-tools package uses such tests in "rngd", and lets you
 	run them by hand with a "rngtest" utility.
 
-	/dev/hw_random is char device major 10, minor 183.
+	/dev/hwrng is char device major 10, minor 183.
 
 	CLASS DEVICE.  There is a /sys/class/misc/hw_random node with
 	two unique attributes, "rng_available" and "rng_current".  The
 	"rng_available" attribute lists the hardware-specific drivers
 	available, while "rng_current" lists the one which is currently
-	connected to /dev/hw_random.  If your system has more than one
+	connected to /dev/hwrng.  If your system has more than one
 	RNG available, you may change the one used by writing a name from
 	the list in "rng_available" into "rng_current".
 
-- 
1.9.1
